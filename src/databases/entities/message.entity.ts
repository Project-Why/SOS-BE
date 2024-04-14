import {
  Column,
  CreateDateColumn,
  Entity,
  OneToOne,
  PrimaryGeneratedColumn,
} from 'typeorm'

@Entity()
export class Message {
  @PrimaryGeneratedColumn()
  id!: number

  @Column('varchar')
  code: string

  @CreateDateColumn({ type: 'timestamp' })
  createdAt!: Date
}
