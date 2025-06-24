# 1. Base image
FROM node:20-alpine AS deps
WORKDIR /app

# 2. Install dependencies
COPY package.json package-lock.json ./
RUN npm ci

# 3. Copy app files
COPY . .

# 4. Build the app (with env support)
ARG NEXT_PUBLIC_API_URL
ENV NEXT_PUBLIC_API_URL=$NEXT_PUBLIC_API_URL
RUN npm run build

# 5. Run app using production server
EXPOSE 80
CMD ["npm", "start"]
