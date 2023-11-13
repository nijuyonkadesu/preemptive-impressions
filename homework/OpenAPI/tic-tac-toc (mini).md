```yaml
openapi: 3.0.0
info:
  title: Tic-Tac-Toe API
  description: This API allows users to play a game of Tic-Tac-Toe.
  version: 1.0.0
servers:
  - url: http://localhost:8080/
paths:
  /game:
    get:
      summary: Get the current game state
      description: Retrieves the current state of the Tic-Tac-Toe game.
      tags:
        - Game
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema: $ref:'#/components/schemas/GameState'
    post:
      summary: Make a move
      description: Allows a player to make a move in the Tic-Tac-Toe game.
      requestBody:
        required: true
        content:
          application/json:
            schema: $ref:'#/components/schemas/Move'
      tags:
        - Game
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema: $ref:'#/components/schemas/GameState'
        '400':
          description: Invalid move
          content:
            text/html:
              schema: $ref:'#/components/schemas/ErrorMessage'
components:
  schemas:
    GameState:
      type: object
      properties:
        board:
          type: array
          items:
            $ref: '#/components/schemas/Mark'
        currentPlayer:
          type: string
          enum: ['X', 'O']
        winner:
          type: string
          enum: ['X', 'O', '.']
    Mark:
      type: string
      enum: ['X', 'O', '.']
    Move:
      type: object
      properties:
        row:
          type: integer
          minimum: 0
          maximum: 2
        column:
          type: integer
          minimum: 0
          maximum: 2
    ErrorMessage:
      type: string
      maxLength: 256

```

**components**: `GameState`, `Mark`, `Move`, `ErrorMessage` - like data class in `kotlin`
note how **schema** doesn't have harcoded values, instead they ***ref*** to components ~~(data classes)~~

reference are json references, fragment reference
```
$ref: 'https://gigantic-server.com/schemas/Monster/schema.yaml'
$ref: './another_file.yaml#rowParam'
```