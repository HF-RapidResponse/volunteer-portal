# Use gcloud nodejs image.
FROM launcher.gcr.io/google/nodejs

# Set working directory.
WORKDIR /usr/src/app/

# Copy application info.
COPY package.json .
COPY package-lock.json .

# Install dependencies.
RUN npm install

# Install serve as a global.
RUN npm install -g serve

# Make default hosting port available.
EXPOSE 8080

# Sets the serve command as the container's main instruction.
CMD ["serve", "-s", "build"]

# Copy remaining application code.
COPY . .

# Build the static site.
RUN npm run build
