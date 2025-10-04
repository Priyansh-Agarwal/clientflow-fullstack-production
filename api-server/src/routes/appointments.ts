import { Router } from 'express';
import { AppointmentController } from '../controllers/appointmentController';
import { authenticateToken } from '../middleware/auth';
import { validateRequest, validateQuery } from '../middleware/validation';
import { 
  createAppointmentSchema, 
  updateAppointmentSchema,
  updateAppointmentStatusSchema,
  getAppointmentsSchema 
} from '../validation/appointmentSchemas';

const router = Router();

// All appointment routes require authentication
router.use(authenticateToken);

/**
 * @route   POST /appointments
 * @desc    Create a new appointment
 * @access  Private (authenticated users)
 * @body    { customer_id?, customer_name, customer_phone, customer_email?, service_id?, service_name, scheduled_at, duration?, total_price?, notes?, etc. }
 */
router.post('/', 
  validateRequest(createAppointmentSchema),
  AppointmentController.createAppointment
);

/**
 * @route   GET /appointments
 * @desc    Get paginated list of appointments with filtering
 * @access  Private (authenticated users)
 * @query   start_date?, end_date?, status?, customer_id?, customer_search?, service_id?, page?, limit?, sort_by?, sort_order?, payment_status?, include_cancelled?
 */
router.get('/', 
  validateQuery(getAppointmentsSchema),
  AppointmentController.getAppointments
);

/**
 * @route   GET /appointments/:id
 * @desc    Get a single appointment by ID
 * @access  Private (authenticated users)
 */
router.get('/:id', 
  AppointmentController.getAppointmentById
);

/**
 * @route   PUT /appointments/:id
 * @desc    Update an appointment (service_type, scheduled_at, duration, etc.)
 * @access  Private (authenticated users)
 * @body    { customer_name?, customer_phone?, service_name?, scheduled_at?, duration?, total_price?, notes?, etc. }
 */
router.put('/:id', 
  validateRequest(updateAppointmentSchema),
  AppointmentController.updateAppointment
);

/**
 * @route   PUT /appointments/:id/status
 * @desc    Update appointment status with SMS notifications
 * @access  Private (authenticated users)
 * @body    { status, cancellation_reason?, cancellation_fee?, notes? }
 */
router.put('/:id/status', 
  validateRequest(updateAppointmentStatusSchema),
  AppointmentController.updateAppointmentStatus
);

/**
 * @route   DELETE /appointments/:id
 * @desc    Cancel an appointment (soft delete)
 * @access  Private (authenticated users)
 */
router.delete('/:id', 
  AppointmentController.deleteAppointment
);

export default router;
