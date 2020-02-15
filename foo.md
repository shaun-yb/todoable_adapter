curl \
    -u shauncarland@gmail.com:todoable \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -X POST \
    https://todoable.teachable.tech/api/authenticate


"03653ca1-adb8-4eb8-a5ea-f7d5cf6f1e7f"

GET ALL LISTS

curl \
  -H "Authorization: Token token=\"df774d47-9d07-4875-8b23-bfae8116a269\"" \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  https://todoable.teachable.tech/api/lists/1


curl -i \
  -H "Authorization: Token token=\"be08f1f4-c315-4d59-9c7c-d7a8b45a7db5\""
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -X GET \
  https://todoable.teachable.tech/api/lists/1

"be08f1f4-c315-4d59-9c7c-d7a8b45a7db5"
