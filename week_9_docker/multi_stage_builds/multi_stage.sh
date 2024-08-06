# Stage 1: Build stage
FROM node:14-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json files to the container
COPY package.json .

# Install dependencies
RUN npm install

# Copy the entire application to the working directory
COPY . .

# Set environment variable for production
ENV NODE_ENV=production

# Build the application
RUN npm run build

# Stage 2: Production stage
FROM nginx:1.21.0-alpine AS production

# Set environment variable for production
ENV NODE_ENV=production

# Copy the built application from the build stage to Nginx's html directory
COPY --from=builder /app/build /usr/share/nginx/html

# Verify the contents of the directory
RUN ls -latr /usr/share/nginx/html

# Copy the Nginx configuration file to the container
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80 to allow access to the application
EXPOSE 80

# Start Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]
