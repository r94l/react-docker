# set the base image to create the image for the react app.
FROM node:25-alpine

# Create a user with permissions to run the app.
# -S flag is used to create a system user, and -G flag is used to specify the group for the user.
# This is done to avoid running the application as the root user, which is a security best practice. By creating a non-root user and running the application under that user, we can limit the potential damage that could be caused by a security vulnerability in the application.
# If the app is run as root, a malicious actor could potentially gain access to the entire system if they were able to exploit a vulnerability in the application. By running the app as a non-root user, we can limit the potential damage that could be caused by a security vulnerability in the application.


RUN addgroup && adduser -S -G app app

# Set the user to run the application.

USER app

# Set the working directory to /app, which is where the application code will be copied to. This is done to ensure that all subsequent commands are run in the context of the /app directory, which is where the application code will be located.

WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory. This is done to ensure that the dependencies for the application can be installed correctly.
# If the package.json and package-lock.json files haven't changed since the last build, Docker will use the cached layer for this step, which can speed up the build process.

COPY package*.json ./

# Sometimes the ownership of the files in the working directory is changed to root
# and thus the app can't access the files and throws an error -> EACCES: permission denied, open 'package.json'
# To fix this, we can change the ownership of the files in the working directory to the root user.

USER root

# change the ownership of the /app directory to the app user. This is done to ensure that the app user has the necessary permissions to access the files in the /app directory.
# chown -R <user>:<group> <directory> is the command used to change the ownership of a directory and its contents. The -R flag is used to apply the changes recursively to all files and subdirectories within the specified directory.

RUN chown -R app:app .

# Switch back to the app user to run the application.

USER app

# Install the dependencies for the application. This is done to ensure that all the necessary packages are installed for the application to run correctly.

RUN npm install

# Copy the rest of the application code to the working directory. This is done to ensure that all the necessary files for the application are available in the container.

COPY . .

# Expose the port that the application will run on. This is done to allow external access to the application when the container is running.

EXPOSE 5173

# Command to start the application. This is done to ensure that the application starts when the container is run.

CMD npm run dev
