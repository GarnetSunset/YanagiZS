# Base builder stage
FROM rust:alpine as builder

WORKDIR /app

# Install dependencies for building
RUN apk add --no-cache musl-dev

# Copy source code
COPY . .

# Build the specified service only
ARG SERVICE
RUN cargo build --release --bin ${SERVICE}

# Final runtime stage
FROM alpine:latest
WORKDIR /app

# Pass the SERVICE variable explicitly into the final stage
ARG SERVICE
ENV SERVICE=${SERVICE}

# Copy the binary of the specified service
COPY --from=builder /app/target/release/${SERVICE} /usr/local/bin/${SERVICE}

# Use shell form ENTRYPOINT for dynamic resolution
ENTRYPOINT sh -c "/usr/local/bin/$SERVICE"
