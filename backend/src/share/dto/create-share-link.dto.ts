// src/share/dto/create-share-link.dto.ts
import { IsEnum, IsISO8601, IsOptional } from 'class-validator';

// Definir enum nativo para validación (debe coincidir con Prisma)
export enum ProjectRoleEnum {
  OWNER = 'OWNER',
  ADMIN = 'ADMIN',
  EDITOR = 'EDITOR',
  VIEWER = 'VIEWER',
}

export class CreateShareLinkDto {
  @IsEnum(ProjectRoleEnum, { message: 'role inválido' })
  role!: ProjectRoleEnum; // normalmente VIEWER

  @IsOptional()
  @IsISO8601({ strict: true }, { message: 'expiresAt debe ser ISO8601' })
  expiresAt?: string; // opcional, ej: "2025-12-31T23:59:59.000Z"
}
