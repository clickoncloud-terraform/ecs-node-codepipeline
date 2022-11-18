FROM public.ecr.aws/d0d0z1i8/node14:latest

# Create app directory
WORKDIR /usr/src/app
COPY node-code/package*.json ./
RUN npm install
COPY node-code/index.js .
EXPOSE 80
CMD [ "node", "index.js" ]
