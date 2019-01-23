# Comparison Between Yocto ESDK and Dockcross

## Background

After having a yocto image running on a target machine, the next step is application development. Write a program and use cross-compile toolchain to compile the application so it can run on the target machine.  
For application development, we have two tools to leverage on. One is yocto toolchain. The other is dockcross. Below is the comparison between these two methods.

## Comparison

| | Yocto ESDK | Dockcross| Comment |
|:---|:---|:---|:---|
| Usage |[build-app-with-yocto-esdk](./app_development/yocto_esdk/build_app_with_yocto_esdk.md) |[build_app_with_dockcross](./app_development/dockcross/build_app_with_dockcross.md) | Both can use a Dockerfile to compile app in one step. Differences are that   |
| Content | yocto extsdk-container contains: <br/> * Cross-Development Toolchain <br/> * Libraries, Headers, and Symbols <br/> * Environment Setup Script | Platform-specific toolchain (including cross-compile toolchain; libraries, headers, etc. Roughly the same thing as yocto SDK toolchain)  | |
| Size | crops/yocto:ubuntu-16.04-base: 743MB <br/> Toolchain: 1.243GB(Store in local volume)<br/> **yocto-azure-image: 3.11GB** | dockcross/base: 793MB <br/>dockcross/linux-arm64: 1.24GB  <br/>**dockcross-azure-image: 1.68GB** | Yocto SDK requires more disk because it actually download toolchain twice!! <br/>The reason for this is that yocto toolchain is not very handy to be extended. The toolchain shell script will download toolchain(2.1GB) and go into container directly, which is not what we want. To wrap it in a Dockerfile, we have to ignore the automatically downloaded toolchain and manually download one, which is ugly and waste a lot of disk space as long as time. <br/>(Use `docker history <image-name>` to see more infomation of the image you just built.) | 
| Pros and Cons | Pros: <br/> 1. Libraries needed can easily added. Just generate SDK with customized configuration. <br/> 2. Yocto has a mature community. Update and maintanance have more garantee. <br/>3. Yocto toolchain is an **enterprise production**, which has more exterprise credibility. <br/><br/> Cons: <br/> 1. Yocto SDK is not designed for extend. Thus extension of yocto toolchain to wrap application development is not as elegant as dockcross. <br/> 2. Require **more disk size**.    | Pros: <br/> 1. Scalable. dockcross is born to extend. <br/> 2. No need to maintain a machine-specific toolchain. Just install your additionally needed libraries in Dockerfile.  <br/><br/> Cons: <br/> 1. **Privately Owned**. May lacks Enterprise credibility. Maintainance and updates may be late or uncontrolable. <br/>   | Although yocto esdk toolchain has the advantage that customized libraries can be easily added into toolchain, fact is that in most situation dockcross build-in cross-compile library can meet our needs. <br/>In situation that we need machine-specific libraries, we manually add the needed library in Dockerfile just like we do in [building azure app with dockercross](./dockcross/examples/dockcross_azure/Dockerfile) |


### Q & A

* What's in BSP(Board Support Packages)?  
    For yocto eSDK toolchain, we can use configure files to install libraries for a specific target machine. However, since different machine of the same company(eg, Raspberry, NXP) usually differs a lot. In most case, these machines have **different architectures**. The BSP mainly installs cross-development toolchain for the specific machine's architecture, libraries for this architecture and some additional library for special customization. For example, bluetooth.  
    That is to say, in most case, the architecture-specific cross-compile toolchain can meet our needs. If user needs special libraries for their boards, it's also handy for them to simply add a line in Dockerfile to install the library.  
    In another aspect, it's not that sensable that we maintain a machine-specific toolchain for several company's boards. It's likely that machines with the same CPU have their different and special hardware features.

## Conclusion & Optimization

No matter which on we choose to use, we have a lot of room for optimization.

* Shorten time needed to build image.
    * Remove useless packages to refine our base image.
    * Use best practice to simplify Dockerfile.
    * Even `git` can be simplified -- use git RESTful API instead of calling git cli.
* Support imx.6 hardware.