FROM node:20-alpine AS build

WORKDIR /usr/src/app

COPY . ./

RUN yarn install
RUN yarn build

FROM node:20-alpine AS deploy

WORKDIR /usr/src/app

RUN npm i -g prisma

COPY --from=build /usr/src/app/dist ./dist
COPY --from=build /usr/src/app/package.json ./package.json
COPY --from=build /usr/src/app/yarn.lock ./yarn.lock
COPY --from=build /usr/src/app/prisma ./prisma

RUN yarn install --production

RUN yarn prisma generate

EXPOSE 3333

CMD ["yarn", "start"]