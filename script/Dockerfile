# Use the official Python image from the Docker Hub
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the Python script into the container
COPY parsejson.py .

# Install any necessary dependencies
# RUN pip install <your-dependencies>  # Uncomment and modify if you have dependencies
RUN pip install requests mysql-connector-python

# Command to run the script
CMD ["python", "parsejson.py"]