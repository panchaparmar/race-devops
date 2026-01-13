# ---------- Build stage ----------
FROM node:18-alpine AS build
WORKDIR /apps/race-devops

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build -- --configuration production

# ---------- Runtime stage ----------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*

# IMPORTANT: copy browser output
COPY --from=build apps/race-devops/dist/simple-dashboard/browser /usr/share/nginx/html/

RUN chmod -R 755 /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

