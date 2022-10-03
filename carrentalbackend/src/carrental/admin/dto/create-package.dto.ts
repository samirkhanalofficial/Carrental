import { IsNotEmpty, IsNumber, IsString } from 'class-validator';

export class CreatePackageDto {
  @IsString()
  @IsNotEmpty()
  source: string;

  @IsString()
  @IsNotEmpty()
  destination: string;

  @IsString()
  @IsNotEmpty()
  vehicleType: string;

  @IsNumber()
  @IsNotEmpty()
  price: number;
}
