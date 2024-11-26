FROM rust:alpine as builder

WORKDIR /app

# Install dependencies for building
RUN apk add --no-cache musl-dev

# Copy source code
COPY . .

# Build each binary target
RUN cargo build --release --bin yanagi-autopatch-server
RUN cargo build --release --bin yanagi-sdk-server
RUN cargo build --release --bin yanagi-dispatch-server
RUN cargo build --release --bin yanagi-gate-server
RUN cargo build --release --bin yanagi-game-server

# Create a minimal runtime image for each binary
FROM alpine as yanagi-autopatch-server
COPY --from=builder /app/target/release/yanagi-autopatch-server /usr/local/bin/
CMD ["yanagi-autopatch-server"]

FROM alpine as yanagi-sdk-server
COPY --from=builder /app/target/release/yanagi-sdk-server /usr/local/bin/
CMD ["yanagi-sdk-server"]

FROM alpine as yanagi-dispatch-server
COPY --from=builder /app/target/release/yanagi-dispatch-server /usr/local/bin/
CMD ["yanagi-dispatch-server"]

FROM alpine as yanagi-gate-server
COPY --from=builder /app/target/release/yanagi-gate-server /usr/local/bin/
CMD ["yanagi-gate-server"]

FROM alpine as yanagi-game-server
COPY --from=builder /app/target/release/yanagi-game-server /usr/local/bin/
CMD ["yanagi-game-server"]
