# ----------- Stage 1: Build --------------
FROM public.ecr.aws/docker/library/node:16 AS build

# Set working directory inside the container
WORKDIR /app

# Copy only package files first for caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build your project (e.g., Vue/React/Angular etc.)
RUN npm run build

# ----------- Stage 2: Nginx Server --------------
FROM public.ecr.aws/docker/library/nginx:latest

# Copy custom Nginx config if you have one
COPY default.conf /etc/nginx/conf.d/default.conf

# Copy the built static files from the build stage
COPY --from=build /app/dist/events-website /usr/share/nginx/html

EXPOSE 3000
