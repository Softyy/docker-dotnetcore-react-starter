FROM node:13.12 AS client-build

WORKDIR /usr/app

ENV PATH /usr/app/node_modules/.bin:$PATH

COPY ./package.json /usr/app/

RUN yarn

COPY . /usr/app

EXPOSE 3000

ENTRYPOINT ["yarn","start"]
