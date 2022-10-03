import {
  Contains,
  IsDateString,
  IsMobilePhone,
  IsNotEmpty,
  IsString,
  Max,
  MaxLength,
  MinLength,
} from 'class-validator';

export class CreateOrderDto {
  @IsString()
  @IsNotEmpty()
  packageId: string;

  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsMobilePhone()
  @Contains('+977')
  @MinLength(14)
  @MaxLength(14)
  @IsNotEmpty()
  mobile: string;

  @IsString()
  @IsDateString()
  @IsNotEmpty()
  date: string;
}
