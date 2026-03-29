# 🔐 BMAD Design Contracts

**Version**: 1.1  
**Last Updated**: 2026-03-29  
**Purpose**: Define strict layer separation and communication rules for TooXTips

---

## 🧱 BMAD Layers (Authoritative)

BMAD consists of exactly four layers:

1. **backend/** → Business logic & services
2. **model/** → Pure data structures & validation
3. **api/** → External interfaces & controllers
4. **database/** → Persistence & queries

No other layers may perform these roles.

---

## 🔁 Allowed Communication Paths

Only the following communication is allowed:

```
api/ → backend/ → model/
backend/ → database/ → model/
```

### 🚫 Forbidden Paths

- api/ → database/ (Direct database access from API)
- api/ → model/ directly (API should use backend)
- backend/ → api/ (Backend should not call API)
- model/ → database/ (Models should not access database)
- database/ → api/ (Database should not call API)

---

## 📦 Data Transfer Rules

Each layer uses its own data type:

### API Layer
- **Data Type**: DTO (Data Transfer Object)
- **Purpose**: External communication
- **Rules**:
  - Must NOT return database entities
  - Must NOT expose internal models
  - Must validate all inputs
  - Must transform data for clients

### Backend Layer
- **Data Type**: Domain Objects
- **Purpose**: Business logic
- **Rules**:
  - Must NOT expose ORM models
  - Must NOT expose database schemas
  - Must encapsulate business rules
  - Must handle all validation

### Model Layer
- **Data Type**: Schemas / Types
- **Purpose**: Data structure definition
- **Rules**:
  - Must NOT contain business logic
  - Must NOT contain I/O operations
  - Must be pure data structures
  - Must define validation rules

### Database Layer
- **Data Type**: Raw Records
- **Purpose**: Persistence
- **Rules**:
  - Must NOT contain validation logic
  - Must NOT contain business rules
  - Must handle transactions
  - Must manage relationships

---

## 📋 Layer Responsibilities

### API Layer (`api/`)

**Responsibilities**:
- Handle HTTP/RPC input & output
- Perform request validation
- Map DTOs to domain inputs
- Map domain outputs to DTOs
- Handle authentication/authorization
- Return appropriate HTTP status codes
- Format error responses

**What NOT to do**:
- Business logic
- Database queries
- Data transformation (beyond DTO mapping)
- Caching logic

**Example Structure**:
```
api/
├── routes/
│   ├── auth.ts
│   ├── tutoring.ts
│   └── progress.ts
├── controllers/
│   ├── authController.ts
│   ├── tutoringController.ts
│   └── progressController.ts
├── middleware/
│   ├── auth.ts
│   ├── validation.ts
│   └── errorHandler.ts
└── dtos/
    ├── authDtos.ts
    ├── tutoringDtos.ts
    └── progressDtos.ts
```

### Backend Layer (`backend/`)

**Responsibilities**:
- Contain all business logic
- Orchestrate workflows
- Call model and database via interfaces
- Handle domain-level validation
- Implement business rules
- Manage transactions

**What NOT to do**:
- HTTP handling
- Database queries (use database layer)
- API response formatting
- Request validation (use API layer)

**Example Structure**:
```
backend/
├── services/
│   ├── authService.ts
│   ├── tutoringService.ts
│   └── progressService.ts
├── domain/
│   ├── User.ts
│   ├── TutoringSession.ts
│   └── Progress.ts
├── repositories/
│   ├── IUserRepository.ts
│   ├── ITutoringRepository.ts
│   └── IProgressRepository.ts
└── validators/
    ├── userValidator.ts
    └── sessionValidator.ts
```

### Model Layer (`model/`)

**Responsibilities**:
- Define data schemas
- Define TypeScript types
- Define validation rules
- Define constants
- Define enums

**What NOT to do**:
- Business logic
- I/O operations
- Database queries
- API calls
- Side effects

**Example Structure**:
```
model/
├── schemas/
│   ├── user.schema.ts
│   ├── tutoring.schema.ts
│   └── progress.schema.ts
├── types/
│   ├── user.types.ts
│   ├── tutoring.types.ts
│   └── progress.types.ts
├── validation/
│   ├── user.validation.ts
│   └── session.validation.ts
└── constants/
    └── index.ts
```

### Database Layer (`database/`)

**Responsibilities**:
- Handle persistence
- Execute queries
- Manage migrations
- Manage relationships
- Handle transactions
- Implement repositories

**What NOT to do**:
- Business logic
- Validation logic
- API logic
- Caching logic

**Example Structure**:
```
database/
├── migrations/
│   ├── 001_create_users.ts
│   ├── 002_create_sessions.ts
│   └── 003_create_progress.ts
├── repositories/
│   ├── UserRepository.ts
│   ├── TutoringRepository.ts
│   └── ProgressRepository.ts
├── models/
│   ├── User.ts
│   ├── TutoringSession.ts
│   └── Progress.ts
└── seeds/
    └── index.ts
```

---

## 🔄 Data Flow Examples

### Example 1: User Registration

```
1. API receives POST /auth/register with DTO
   ↓
2. API validates DTO (request validation)
   ↓
3. API calls backend.registerUser(userData)
   ↓
4. Backend validates business rules
   ↓
5. Backend calls database.createUser(userData)
   ↓
6. Database creates user record
   ↓
7. Database returns raw record
   ↓
8. Backend transforms to domain object
   ↓
9. API transforms to response DTO
   ↓
10. API returns HTTP 201 with DTO
```

### Example 2: Get User Progress

```
1. API receives GET /progress/:userId
   ↓
2. API validates userId parameter
   ↓
3. API calls backend.getUserProgress(userId)
   ↓
4. Backend calls database.getProgress(userId)
   ↓
5. Database queries and returns raw records
   ↓
6. Backend transforms to domain objects
   ↓
7. Backend applies business logic (calculations, etc.)
   ↓
8. API transforms to response DTO
   ↓
9. API returns HTTP 200 with DTO
```

---

## ✅ Contract Enforcement Checklist

Before any PR or task completion, verify:

- [ ] API only uses DTOs for input/output
- [ ] API does not call database directly
- [ ] Backend only uses domain objects
- [ ] Backend does not expose ORM models
- [ ] Model only contains schemas/types
- [ ] Model contains no business logic
- [ ] Database only contains queries/migrations
- [ ] Database contains no validation logic
- [ ] All data flows through proper layers
- [ ] No forbidden communication paths exist

---

## 🚫 Common Violations

### ❌ Violation 1: API Calling Database
```typescript
// WRONG - API calling database directly
app.get('/users/:id', async (req, res) => {
  const user = await db.query('SELECT * FROM users WHERE id = ?', [req.params.id]);
  res.json(user);
});

// CORRECT - API calling backend
app.get('/users/:id', async (req, res) => {
  const user = await userService.getUser(req.params.id);
  res.json(userDTO.fromDomain(user));
});
```

### ❌ Violation 2: Backend Exposing ORM Models
```typescript
// WRONG - Backend returning ORM model
async getUser(id: string) {
  return await User.findById(id); // Returns ORM model
}

// CORRECT - Backend returning domain object
async getUser(id: string) {
  const record = await userRepository.findById(id);
  return new User(record.id, record.name, record.email);
}
```

### ❌ Violation 3: Model Containing Logic
```typescript
// WRONG - Model with business logic
export class User {
  calculateScore() {
    // Business logic in model
    return this.points * this.multiplier;
  }
}

// CORRECT - Logic in backend service
export class UserService {
  calculateScore(user: User): number {
    return user.points * user.multiplier;
  }
}
```

### ❌ Violation 4: Database Containing Validation
```typescript
// WRONG - Validation in database
async createUser(data: any) {
  if (!data.email) throw new Error('Email required');
  return await db.insert('users', data);
}

// CORRECT - Validation in backend
async createUser(data: any) {
  validateUserData(data); // Validation in backend
  return await userRepository.create(data);
}
```

---

## 📊 Dependency Direction

The dependency direction must always be:

```
API → Backend → Model
      ↓
    Database → Model
```

**Never reverse these dependencies.**

---

## 🔐 Security Implications

Strict layer separation provides security benefits:

1. **Input Validation**: All external input validated at API layer
2. **Authorization**: Enforced at API and backend layers
3. **Data Protection**: Sensitive data transformations in backend
4. **Audit Trail**: Clear data flow for logging and monitoring
5. **Vulnerability Isolation**: Bugs in one layer don't compromise others

---

## 📚 References

- BMAD Architecture Pattern
- Clean Architecture Principles
- Separation of Concerns
- Dependency Inversion Principle
