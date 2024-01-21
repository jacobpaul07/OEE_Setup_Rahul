# OEE Setup

An installation document for OEE

```
git clone https://gitlab.intranet.siqsess.com/oee/oee-setup.git
```
Use your GITLAB(Siqsess ID) credentials to authenticate clone from gitlab.
#### Navigate inside the oee-setup directory and switch to root user
```
cd oee-setup
sudo su
```
#### Grant permission to execute the bash files
```
chmod +x file_update.sh start-up.sh docker-install.sh
```
#### Execute the *file_update.sh*
```
./file_update.sh
```
On execution of file_update.sh, below questions should be answered
- Please enter your Edge Device IP  
    ```
    You can find local IP address by the following command   
    
    $ ifconfig
    
    Example: 192.168.1.49
    ```
- Please enter your Source PLC/Machine IP
    
    ```
    Enter the MTConnect IP Address 
	
    Example: 148.244.99.83 
    ```

- Please enter your Machine name 
    
    ```bash
    Enter your machine name 

	Example: ST-10
    ```
   
This will unpack the file and update Edge device IP address, PLC/Machine IP address and the Machine name. 

#### Execute *start-up.sh* file
```
./start-up.sh
```
*start-up.sh* file will download, install docker, docker-compose, pull and up BackEnd, FrontEnd and Kafka images.

#### Monitoring
Once done visit *edgedeviceip:9080* in browser to view live data.

Example :
    http://192.168.1.49:9080/ 
