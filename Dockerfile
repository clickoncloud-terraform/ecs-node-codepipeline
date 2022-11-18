FROM public.ecr.aws/d0d0z1i8/node14:latest

# Create app directory
WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3001
CMD [ "node", "index.js" ]
