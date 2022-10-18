# exams-webapp-backend
### 📍 Technologies
&ensp;<img src="https://user-images.githubusercontent.com/71220483/167238852-78f6a958-0037-4d08-a1a1-52f488454529.svg" width="80"/> &nbsp; <img src="https://user-images.githubusercontent.com/71220483/167238874-e12bf41b-7ce6-4c07-a822-26d443dc3164.svg" width="40"/> &nbsp;  <img src="https://raw.githubusercontent.com/MaccaTech/PostgresPrefs/master/PostgreSQL/Images/elephant.png" width="40"/> &nbsp; 
---
 ### 📍 Prerequisites
* you need to have docker, and docker-compose installed on your machine
---
### 🛠 Instructions
---
&ensp; After cloning this repo  
1. ``` $ cd exams-webapp-backend ```
2. ``` $ chmod +x docker-entrypoint.sh ```
3. ``` $ cp env.template .env ```
4. ``` $ sudo docker-compose build ```  
5. ``` $ sudo docker-compose up ```  

* Access API through:
    > http://localhost:3000
* Access Database through:
    > http://localhost:5433

### ``` ⚠️ Note: .SSH directory is copied into the container so you can execute git commands to the repo from the container if you have .git configured to work with SSH keys  ``` 
