# Fiesta App - Issue Tracking System

## Overview

This document outlines the standardized issue tracking system implemented for the Fiesta movie and TV show discovery application. Each issue is assigned a unique identifier to facilitate tracking, discussion, and referencing in commits, documentation, and team communication.

## Issue ID Format

The issue tracking system follows this pattern:

```
ISSUE-FT{XXX}
```

Where:
- **ISSUE-** - Standard prefix indicating this is an issue tracker entry
- **FT** - Project identifier for "Fiesta"
- **{XXX}** - Three-digit sequential number (e.g., 001, 002, 003)

## Issue Categories

Issues are categorized by their first digit to indicate the general domain of the problem:

- **ISSUE-FT0XX** - Core infrastructure and dependency issues
- **ISSUE-FT1XX** - Authentication and user management issues
- **ISSUE-FT2XX** - UI/UX and presentation layer issues
- **ISSUE-FT3XX** - API integration and data handling issues 
- **ISSUE-FT4XX** - Navigation and routing issues
- **ISSUE-FT5XX** - State management issues
- **ISSUE-FT9XX** - Miscellaneous/uncategorized issues

## Issue Documentation Format

Each documented issue should include:

1. **ID**: The unique issue identifier (e.g., ISSUE-FT001)
2. **Title**: Brief, descriptive title of the issue
3. **Description**: Detailed explanation of the problem
4. **Error Message**: The exact error message if applicable
5. **Root Cause**: Analysis of what caused the issue
6. **Solution**: How the issue was resolved
7. **Affected Files**: List of files that were modified to fix the issue
8. **Fixed In**: Commit hash or version where the fix was applied

## Current Issues

### ISSUE-FT001: Dependency Injection Failure

- **Title**: Dependency Injection Registration Error
- **Description**: Application crashes at launch due to improper dependency registration
- **Error Message**: `Bad state: GetIt: Object/factory with type int is not registered inside GetIt`
- **Root Cause**: The app was trying to register the Watchmode API key as an int when it should be a string and was using auto-generated code that had errors
- **Solution**: Created a new manual DI setup in `lib/di/injection.dart` that properly registers all dependencies without relying on code generation
- **Affected Files**: 
  - Created: `lib/di/injection.dart`
  - Modified: `lib/main.dart`
- **Fixed In**: Commit "Fix authentication type casting and DI errors"

### ISSUE-FT002: Authentication Type Casting Error

- **Title**: Authentication Type Casting Error in AuthCubit
- **Description**: Login screen shows type error when attempting to authenticate
- **Error Message**: `type 'Left<Failure, User>' is not a subtype of type 'User?' in type cast`
- **Root Cause**: Direct casting of `Either<Failure, User>` to `User` in the AuthCubit, which fails when the operation returns a Left (error) result
- **Solution**: Updated AuthCubit to properly use `fold()` to handle the Either type returned by use cases
- **Affected Files**:
  - Modified: `lib/presentation/cubit/auth_cubit.dart`
  - Modified: `lib/presentation/home/tabs/profile_tab.dart`
- **Fixed In**: Commit "Fix authentication type casting and DI errors"

## Using Issue IDs in Commits

When fixing an issue, include the issue ID in the commit message for easy reference:

```
Fix user authentication flow (ISSUE-FT002)
```

For commits addressing multiple issues:

```
Update dependency injection and fix auth errors (ISSUE-FT001, ISSUE-FT002)
```

## Issue Tracking Workflow

1. **Issue Identification**: When a new issue is discovered, assign it the next available ID in the appropriate category
2. **Documentation**: Add the issue to this tracking document with all relevant details
3. **Resolution**: When fixing the issue, reference the ID in commit messages
4. **Closure**: Update the issue entry with the fix details and commit information

This system ensures that all team members can easily track, reference, and understand issues throughout the development lifecycle.
