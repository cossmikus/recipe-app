FROM python:3.9-alpine3.13
LABEL maintainer="londonappdeveloper.com"

# Avoid interactive installs
ENV PYTHONUNBUFFERED=1

# Install dependencies
COPY ./requirements.txt /tmp/requirements.txt
COPY ./app /app

# Install necessary packages, and create virtual environment
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp && \
    apk del .tmp-build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

# Ensure the virtual environment is used
ENV PATH="/py/bin:$PATH"

# Set the working directory
WORKDIR /app

# Set user to django-user
USER django-user

# Expose the necessary port
EXPOSE 8002
