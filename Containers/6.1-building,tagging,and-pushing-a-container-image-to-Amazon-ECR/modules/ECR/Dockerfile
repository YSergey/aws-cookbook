FROM python:3.8-slim
RUN pip install ray
COPY example.py /ray_script.py
CMD ["python", "/ray_script.py"]