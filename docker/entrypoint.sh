#!/bin/bash

if [ -n "$RABBIT_BROKER" ]; then
    sed -i "s/RABBIT_BROKER = .*/RABBIT_BROKER = $RABBIT_BROKER/" settings.py
fi

if [ -n "$RABBIT_BACKEND" ]; then
    sed -i "s/RABBIT_BACKEND = .*/RABBIT_BACKEND = $RABBIT_BACKEND/" settings.py
fi

# Start Celery
/usr/local/bin/celery -A layerindex.tasks worker --loglevel="${CELERY_LOG_LEVEL:-info}" \
                      --workdir=/opt/layerindex &

# Start Gunicorn
/usr/local/bin/gunicorn wsgi:application --workers="${GUNICORN_NUM_WORKERS:-4}" \
                        --bind="${GUNICORN_BIND:-:5000}" \
                        --log-level="${GUNICORN_LOG_LEVEL:-debug}" \
                        --chdir=/opt/layerindex
