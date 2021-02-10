# Build phase
FROM node:alpine
WORKDIR "/app"
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Run phase, we don't have to run spefically nginx, the image does this on it's own
FROM nginx
# Elastic beanstalk needs an exposed port, we define it here and it will automatically look for the instruction
EXPOSE 80
COPY --from=0    /app/build /usr/share/nginx/html