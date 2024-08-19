# Stage 1: Build the Angular app
FROM node:18 AS build-stage

# Set the working directory
WORKDIR /app

# Install Angular CLI globally
RUN npm install -g @angular/cli

# Install project dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app using the production configuration
RUN ng build --configuration=production

# Stage 2: Run the Angular app with a Node.js server
FROM node:18

# Set the working directory
WORKDIR /app

# Copy the built Angular app to the working directory
COPY --from=build-stage /app/dist/testing .

# Install a simple Node.js server to serve the Angular app
RUN npm install -g http-server

# Expose the port that the server will run on
EXPOSE 8080

# Start the Node.js server
CMD ["http-server", ".", "-p", "8080"]