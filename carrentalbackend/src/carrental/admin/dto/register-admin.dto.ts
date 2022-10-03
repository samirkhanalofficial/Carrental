import { IsString, IsNotEmpty, IsEmail, MinLength } from 'class-validator';
export class RegisterAdminDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(3)
  name: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @IsString()
  @IsNotEmpty()
  @IsEmail()
  email: string;
}
