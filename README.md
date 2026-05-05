```mermaid
erDiagram
    USER {
        int id PK
        string name
    }
    POST {
        int id PK
        string title
        text content
    }
    USER ||--|{ POST : makes
```