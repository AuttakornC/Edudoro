# API Doc

## Friend

### - Query friends (already accept)

```bash
GET /api/v1/friends

request:
authRequire - true

response:
200 - {
  'message': 'success',
  'data': {
    'friend_account_id': string,
    'username': string,
    'daily_score': number,
    'decorations': {
      'type': 'icon' | 'frame' | 'name_color',
      'detail': string # src | color_code
    }[],
    'friend_at': Date
  }[]
}

500 - {
  'message': string # system error
}
```

### - Query request

```bash
GET /api/v1/friends/requests

request:
authRequire - true

response:
200 - {
  'message': 'success',
  'data': {
    'requester_id': string,
    'username': string,
    'decorations': {
      'type': 'icon' | 'frame' | 'name_color',
      'detail': string # src | color_code
    }[]
  }[]
}

500 - {
  'message': string # system error
}
```

### - Create request

```bash
POST /api/v1/friends/request

request:
authRequire - true
header - { 'Content-Type': 'application/json' }
body - {
  'username': string;
}

response:
200 - {
  'message': 'success'
}

400 - {
  'message': string # bad request
}

409 - {
  'message': 'already_requested'
}

404 - {
  'message': 'user_not_found'
}

500 - {
  'message': string # system error
}
```

### - Accept request

```bash
PATCH /api/v1/friends/request

request:
authRequire - true
header - { 'Content-Type': 'application/json' }
body - {
  'requester_id': string;
}

response:
200 - {
  'message': 'success'
}

400 - {
  'message': string # bad request
}

404 - {
  'message': 'request_not_found'
}

500 - {
  'message': string # system error
}
```

### - Denied request

```bash
DELETE /api/v1/friends/request/:requester_id

request:
authRequire - true

response:
200 - {
  'message': 'success'
}

404 - {
  'message': 'request_not_found'
}

500 - {
  'message': string # system error
}
```
