FROM oven/bun:1 AS build-stage

WORKDIR /app
COPY package.json bun.lock /app/
COPY frontend/package.json /app/frontend/
WORKDIR /app/frontend
RUN bun install
COPY ./frontend /app/frontend
ARG VITE_API_URL
ENV VITE_API_URL=${VITE_API_URL}
RUN bun run build

FROM nginx:1
COPY --from=build-stage /app/frontend/dist/ /usr/share/nginx/html
RUN find /usr/share/nginx/html -type d -exec chmod 755 {} \; \
 && find /usr/share/nginx/html -type f -exec chmod 644 {} \;
COPY ./frontend/nginx.conf /etc/nginx/templates/default.conf.template
