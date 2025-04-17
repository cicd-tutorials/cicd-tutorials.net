FROM mcr.microsoft.com/playwright:v1.51.1-noble AS base

# Disable interactive configuration
ENV DEBIAN_FRONTEND='noninteractive'

WORKDIR /work
COPY ./entrypoint.sh ./requirements.txt /work/
RUN apt-get update && \
    apt-get install -y \
        python3-pip && \
    pip install --break-system-packages -r requirements.txt && \
    rfbrowser init && \
    chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]


FROM base

COPY suites/ suites/
COPY --from=base /work/entrypoint.sh .
