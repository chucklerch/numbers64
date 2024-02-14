FROM ubuntu AS builder

LABEL stage=builder
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y --quiet make nasm binutils

COPY * ./
RUN make 

FROM scratch
COPY --from=builder numbers /
CMD ["/numbers"]
