FROM node:18

# Create the app source directory
WORKDIR /usr/src/node_app

# Bundle the nodejs application source
COPY ./nodejs_app .

EXPOSE 8080
CMD [ "node", "main.js" ]
