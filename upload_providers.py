import json
import firebase_admin
from firebase_admin import credentials, firestore

# Path to your Firebase service account key JSON
SERVICE_ACCOUNT_PATH = 'servo-smart-app-firebase-adminsdk.json'
PROVIDERS_JSON_PATH = 'sample_providers.json'

def main():
    # Initialize Firebase Admin
    cred = credentials.Certificate(SERVICE_ACCOUNT_PATH)
    firebase_admin.initialize_app(cred)
    db = firestore.client()

    # Load providers data
    with open(PROVIDERS_JSON_PATH, 'r') as f:
        providers = json.load(f)

    # Upload each provider as a new document (auto-ID)
    for provider in providers:
        db.collection('providers').add(provider)
        print(f"Uploaded: {provider['name']} ({provider['serviceType']})")

    print("All providers uploaded successfully.")

if __name__ == '__main__':
    main()