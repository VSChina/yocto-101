# Build Yocto with Azure

After following [yocto-quick-start-tutorial](./buildYoctoRpi101), you now have a general understanding of what yocto is about. In this acticle, we will combine yocto with Azure.

Host machine: Windows 10  
Yocto release: 2.6(master branch)

## Using pacakage Management

In several situations, you might need to update, add, remove, or query the packages on a target device at runtime (i.e. without having to generate a new image), then you need a "runtime package management".

According to the latest [yocto annoucement](https://www.yoctoproject.org/docs/current/ref-manual/ref-manual.html#migration-2.3-package-management-changes), `Smart` package manager is replaced by `DNF` package manager(Yocto 2.3 Release). therefore, in this article, we introduce how to build yocto system with dnf package manager.

Procedures:

1. Configure conf files

    The section uses `core-image-base` image recipe as an example with the following content in **conf/local.conf**:
    - MACHINE ??= "core-image-base"
    - PACKAGE_CLASSES = "package_rpm package_ipk"
    - EXTRA_IMAGE_FEATURES += " package-management "

2. Bitbake image

    Run the following command in build machine:
    ```
    $ source oe-inti-build-env <build-directory>
    $ bitbake core-image-base
    ```

3. Update package indexes
    ```
    $ bitbake package-index
    ```
    This command create package repodata directory under `<build-directory>/tmp/deploy/work/rpm`. Deploy the image in your hardware(Raspberry Pi 3, for example).

4. Set up host or server machine

    For development purposes, you can point the web server to the build system's `deploy` directory. But it's recommended that you copy the package directory `<build-directory>/tmp/deploy/rpm` to a new machine to serve as a web server. Doing so avoids situations where the build system overwrites or changes the deploy directory.

    Set up web server under server machine's deploy/rpm directory:
    ```
    $ python -m SimpleHTTPServer
    Serving HTTP on 0.0.0.0 port 8000 ...
    ```
    Visit http://<server-machine-ip>:8000 from browser to ensure the resource can be accessed.

5. Set up target

    Create a directory for repos. (`-p` parameter will help create parent directories.)
    ```
    # mkdir -p /etc/yum.repos.d 
    ```
    Add repo with name end with `.repo`. For example, we add a `oe-packages.repo` under `/etc/yum.repo.d/` directory.
    ```
    [oe-packages]
    name=oe-packages
    baseurl=http://<server-machine-ip>:8000
    enabled=1
    gpgcheck=0
    ```
    Replace `<server-machine-ip>` with your server machine ip, like `baseurl=http://10.94.200.114:8000` in my case.

    Once you have informed DNF where to find the package databases, you need to fetch them:
    ```
    # dnf makecache
    oe-packages                                    3.9 MB/s | 2.3 MB     00:00
    ```
    After that you can install package you want.
    ```
    # dnf install <package-name>
    ```
    DNF is now able to find, install, and upgrade packages from the specified repository or repositories.


Reference: 

* [Yocto - Using rutime package management](https://www.yoctoproject.org/docs/2.6/dev-manual/dev-manual.html#using-runtime-package-management)
* [Yocto - Enable a package feed](https://wiki.yoctoproject.org/wiki/TipsAndTricks/EnablingAPackageFeed)
* [Use DNF Package Manager on a Yocto-built Development System](https://mindchasers.com/dev/yocto-dnf)
* [Intel - Pacakage Manager White Paper](https://www.intel.com/content/dam/www/public/us/en/documents/white-papers/package-manager-white-paper.pdf)

Troubleshooting:

* If you run `dnf makecache` and get:
    ```
    Warning: failed loading '/etc/yum.repos.d/oe-packages.repo', skipping.
    ```
    This means your oe-packages.repo file is not right. Make sure to use the sample pattern offered above.

* If you run `dnf makecache` and get:
    ```
    Failed to synchronize cache for repo 'oe-packages', ignoring this repo.
    ```
    This means something wrong with the package server, can your MCU ping the server's ip? Is the web server running well?


Tips: We use `core-image-base` recipe for the reason that it has openssh-server built-in. Other image recipe is also okay since you don't have to use ssh to manipulate your MCU.


## 