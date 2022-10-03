import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type OrderDocument = Order & Document;

@Schema({
  timestamps: true,
})
export class Order {
  @Prop({
    required: true,
  })
  name: string;
  @Prop({
    required: true,
  })
  packageId: string;
  @Prop({
    required: true,
  })
  vehicleType: string;
  @Prop({
    required: true,
  })
  mobile: string;
  @Prop({
    required: true,
  })
  date: string;
  @Prop({
    required: true,
  })
  isDone: boolean;
}

export const OrderSchema = SchemaFactory.createForClass(Order);
