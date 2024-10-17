# Use Node.js as the base image
FROM node:14

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json (if available)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of your application files
COPY . .

# Expose the necessary port (default port for your app)
EXPOSE 3000

# Command to run your application
CMD ["node", "app.js"]

