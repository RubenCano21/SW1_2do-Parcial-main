import { IsEmail, IsNotEmpty, MinLength } from 'class-validator';

export class RegisterDto {
  @IsEmail({}, { message: 'Email debe ser válido' })
  email: string;

  @IsNotEmpty({ message: 'Nombre es requerido' })
  name: string;

  @MinLength(6, { message: 'Contraseña debe tener al menos 6 caracteres' })
  password: string;
}