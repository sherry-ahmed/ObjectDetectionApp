
from flask import Flask, request, jsonify
from PIL import Image
import requests
from io import BytesIO
import torch
from torchvision import models, transforms


app = Flask(__name__)

# Load a pre-trained ResNet model
model = models.resnet50(pretrained=True)
model.eval()

# Define the transformation for the input image
preprocess = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# Labels for ImageNet classes
LABELS_URL = "https://raw.githubusercontent.com/anishathalye/imagenet-simple-labels/master/imagenet-simple-labels.json"
LABELS = requests.get(LABELS_URL).json()

def classify_image(image):
    # Preprocess the image
    input_tensor = preprocess(image)
    input_batch = input_tensor.unsqueeze(0)

    # Perform inference
    with torch.no_grad():
        output = model(input_batch)

    # Get the predicted class
    _, predicted_idx = torch.max(output, 1)
    predicted_label = LABELS[predicted_idx.item()]

    return predicted_label

@app.route('/classify_image', methods=['POST'])
def classify_image_route():
    try:
        # Receive image from Flutter app
        image_data = request.files['image'].read()
        image = Image.open(BytesIO(image_data))

        # Perform image classification
        result = classify_image(image)

        return jsonify({'result': result})
    except Exception as e:
        return jsonify({'error': str(e)})

if __name__ == '__main__':
    app.run(host='192.168.100.30', port=5000)

