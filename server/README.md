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

### - Search Friend

```bash
GET /api/v1/friends/request

request:
authRequire - true
searchParams: {
  'search': string # a part of username
}

response:
200 - {
  'message': 'success'
}

404 - {
  'message': 'user_not_found'
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
  'friend_id': string;
}

response:
200 - {
  'message': 'success'
}

400 - {
  'message': string # bad request
}

404 - {
  'message': 'user_not_found'
}

409 - {
  'message': 'already_requested'
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

### - Unfriend

```bash
DELETE /api/v1/friends/:friend_id

request:
authRequire - true

response:
200 - {
  'message': 'success'
}

404 - {
  'message': 'friend_not_found'
}

500 - {
  'message': string # system error
}
```

## Shop

### - Query All Shop Items

```bash
GET /api/v1/shop/decorations

request:
authRequire - optional


response:
200 - {
  'message': 'success',
  'data': {
    'icons': {
      'decoration_id': string,
      'detail': string,
      'price': number,
      'owned': bool
    }[],
    'frames': {
      'decoration_id': string,
      'detail': string,
      'price': number,
      'owned': bool
    }[],
    'name_colors': {
      'decoration_id': string,
      'detail': string,
      'price': number,
      'owned': bool
    }[]
  }
}

500 - {
  'message': string # system error
}
```

### - Bought decoration

```bash
POST /api/v1/shop/buy

request:
authRequire - true
header - { 'Content-Type': 'application/json' }
body - {
  'decoration_id': string;
}

response:
201 - {
  'message': 'success'
}

400 - {
  'message': string # bad request
}

402 - {
  'message': 'not_enough_score'
}

404 - {
  'message': 'decoration_not_found'
}

409 - {
  'message': 'already_bought'
}

500 - {
  'message': string # system error
}
```

## Profile

### Current using decorations

```bash
GET /api/v1/profile

request:
authRequire - true


response:
200 - {
  'message': 'success',
  'data': {
    'username': string,
    'email': string,
    'decorations': {
      'decoration_id': string,
      'type': 'icon' | 'frame' | 'name_color',
      'detail': string,
      'bought_at': Date
    }[]
  }
}

500 - {
  'message': string # system error
}
```

### Query all user's decorations

```bash
GET /api/v1/profile/decorations

request:
authRequire - true


response:
200 - {
  'message': 'success',
  'data': {
    'decoration_id': string,
    'type': 'icon' | 'frame' | 'name_color',
    'detail': string,
    'bought_at': Date
  }[]
}

500 - {
  'message': string # system error
}
```

### Use the decorations

```bash
GET /api/v1/profile/use/:decoration_id

request:
authRequire - true


response:
200 - {
  'message': 'success',
}

404 = {
  'message': 'decoration_not_found'
}

500 - {
  'message': string # system error
}
```
