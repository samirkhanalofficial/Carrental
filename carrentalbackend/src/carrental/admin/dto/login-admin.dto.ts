import { IsString, IsNotEmpty, IsEmail, MinLength } from 'class-validator';
export class LoginAdminDto {
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @IsString()
  @IsNotEmpty()
  @IsEmail()
  email: string;
}
