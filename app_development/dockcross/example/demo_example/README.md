# Demo Example Explanation

## Gpio Example

Gpio example is a rather simple example to test RPI's gpio function. Under the `gpio_example` directory, run the following command to build the gpio executable file.

### Compile the Application

```bash
# build the gpio_example image
docker build -t gpio-test .

# Copy the gpio_example executable file to local
CID=$(docker create gpio-test:latest)
docker cp $CID:/work/GPIOBuild/gpio_example .

# Check gpio_example information
file ./gpio_example
```

### Set up RPI and Run the Code

The idea is to develop an application that, through the GPIO pins, lights an LED and monitors a push button.

![Connect RPI with LED and button](https://learning.oreilly.com/library/view/yocto-for-raspberry/9781785281952/graphics/image_05_003.jpg)

Place the gpio_example binary file to your raspberry pi 3 hardware, set up LED for test and execute the binary file.

```bash
root@raspberrypi3-64:~/# ./gpio_example
#################################
#                               #
#          gpio example         #
#              Demo             #
#                               #
#################################

This example show how to used the GPIO from sysfs interface

usage: ./gpio_example options...
 options:
 -l --led=<on|off>
 -b --button
 -v --version display the version number
 -h --help Prints this help

Example: ./gpio_example --led=1
```

## Bme280 Sensor Example

Bme280 sensor example records sensor data like humidity, pressure, temperature, etc. It uses the I2C protocol with the help of WiringPi library.

Since the base image does not contian the wiringpi library, the docker image first compiles wiringPi library then the bcm280 app.

### Build the Application

```bash
# build the bme_project image
docker build -t bme-test .

# Copy the bme_project executable file to local
CID=$(docker create bme-test:latest)
docker cp $CID:/work/BMEBuild/bme280/cmake/bme_project .

# Check bme_project information
file ./bme_project
```

### Run the Code

1. Place the bme_project binary file to your raspberry pi 3 hardware.

2. Create file `/home/root/wiringPi/cpuinfo` on rpi3. This is a workaround for the wiringPi to get hardware version. (This is also a known issue that wiringPi library does not support rpi3-64).

    ```bash
    # /home/root/wiringPi/cpuinfo
    processor       : 0
    BogoMIPS        : 38.40
    Features        : fp asimd evtstrm crc32 cpuid
    CPU implementer : 0x41
    CPU architecture: 8
    CPU variant     : 0x0
    CPU part        : 0xd03
    CPU revision    : 4

    processor       : 1
    BogoMIPS        : 38.40
    Features        : fp asimd evtstrm crc32 cpuid
    CPU implementer : 0x41
    CPU architecture: 8
    CPU variant     : 0x0
    CPU part        : 0xd03
    CPU revision    : 4

    processor       : 2
    BogoMIPS        : 38.40
    Features        : fp asimd evtstrm crc32 cpuid
    CPU implementer : 0x41
    CPU architecture: 8
    CPU variant     : 0x0
    CPU part        : 0xd03
    CPU revision    : 4

    processor       : 3
    BogoMIPS        : 38.40
    Features        : fp asimd evtstrm crc32 cpuid
    CPU implementer : 0x41
    CPU architecture: 8
    CPU variant     : 0x0
    CPU part        : 0xd03
    CPU revision    : 4

    Hardware        : BCM2709
    Revision        : a22082
    Serial          : 00000000fcc1f2f9
    ```

3. Ensure your rpi yocto image has installed i2c-tools.

    ```bash
    # local.conf
    IMAGE_INSTALL_append = " i2c-tools"
    ENABLE_I2C = "1"
    ```

    On RPI3, test whether i2c can work properly:

    ```bash
    root@raspberrypi3-64:~/dilin# lsmod | grep i2c
    i2c_dev                20480  0
    ```

    > If this command does not give out `i2c-dev` as a result, execute:
    >
    > ```bash
    > modprobe i2c-dev
    > ```
    >
    > This command adds `i2c-dev` as a module in the device, so i2c-tools can recognize i2c devices.

    ```bash
    root@raspberrypi3-64:~/dilin# i2cdetect -l
    i2c-1   i2c             bcm2835 I2C adapter                     I2C adapter
    i2c-2   i2c             bcm2835 I2C adapter                     I2C adapter

    root@raspberrypi3-64:~/dilin# i2cdetect -y 1
        0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
    00:          -- -- -- -- -- -- -- -- -- -- -- -- --
    10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    60: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    70: -- -- -- -- -- -- -- 77
    ```

4. Execute the binary file to get bme280 sensor data.

    ```bash
    root@raspberrypi3-64:~/dilin# ./bme_project
    {"sensor":"bme280", "humidity":28.68, "pressure":716.16, "temperature":21.58, "altitude":2830.81, "timestamp":1550838716}
    ```

## Reference

* [book: Yocto for Raspberry Pi](https://learning.oreilly.com/library/view/yocto-for-raspberry/9781785281952/)
* [code: gpio_example.c](https://github.com/PacktPublishing/Yocto-for-Raspberry-Pi/blob/master/Chapter%205/gpio-example.c)