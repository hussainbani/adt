import json


def test_ping_returns_200_OK(client):
    response = client.get("/ping")
    assert response.status_code == 200
    assert b"OK" in response.data


def test_app_endpoint_returns_200_when_token_given(client):
    response = client.get("/app", headers={"X-Auth-Token": "valid"})
    assert response.status_code == 200
    assert response.get_json() == {"message": "Hello World"}


def test_app_endpoint_returns_403_when_invalid_token_given(client):
    response = client.get(
        "/app",
        headers={"X-Auth-Token": "invalid"}
    )
    assert response.status_code == 403


def test_health_endpoint_returns_200(client):
    response = client.get(
        "/health"
    )
    assert response.status_code == 200

    response_data = json.loads(response.get_data(as_text=True))

    assert "hostname" in response_data
    assert "result" in response_data
    assert response_data["status"] == "success"
