-- Simplified schema (20 tables) - PostgreSQL

CREATE TABLE users (
                       id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                       email         VARCHAR(320) NOT NULL UNIQUE,
                       password_hash TEXT NOT NULL,
                       full_name     VARCHAR(200) NOT NULL,
                       phone         VARCHAR(30),
                       role          VARCHAR(20) NOT NULL DEFAULT 'buyer'
                           CHECK (role IN ('buyer', 'seller', 'admin')),
                       is_active     BOOLEAN NOT NULL DEFAULT TRUE,
                       created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE seller_profiles (
                                 user_id             UUID PRIMARY KEY REFERENCES users(id) ON DELETE RESTRICT,
                                 seller_type         VARCHAR(20) NOT NULL DEFAULT 'individual'
                                     CHECK (seller_type IN ('individual', 'pharmacy')),
                                 display_name        VARCHAR(200) NOT NULL,
                                 verification_status VARCHAR(30) NOT NULL DEFAULT 'pending'
                                     CHECK (verification_status IN ('pending', 'verified', 'rejected', 'suspended', 'expired')),
                                 verified_by         UUID REFERENCES users(id) ON DELETE SET NULL,
                                 verified_at         TIMESTAMPTZ,
                                 verification_notes  TEXT
);

-- Only for sellers with seller_type = 'pharmacy' (individuals have no row here)
CREATE TABLE pharmacies (
                            seller_user_id      UUID PRIMARY KEY REFERENCES seller_profiles(user_id) ON DELETE CASCADE,
                            name                VARCHAR(200) NOT NULL,
                            description         TEXT,
                            logo_url            TEXT,
                            phone               VARCHAR(30),
                            license_number      VARCHAR(100) NOT NULL UNIQUE,
                            license_expires_at  DATE,
                            tax_registration_no VARCHAR(100),
                            created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE seller_documents (
                                  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                  seller_user_id UUID NOT NULL REFERENCES seller_profiles(user_id) ON DELETE CASCADE,
                                  document_type  VARCHAR(80) NOT NULL,  -- e.g. national_id, pharmacy_license, tax_card
                                  file_url       TEXT NOT NULL,
                                  review_status  VARCHAR(30) NOT NULL DEFAULT 'pending'
                                      CHECK (review_status IN ('pending', 'approved', 'rejected', 'needs_resubmission')),
                                  uploaded_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_seller_documents_seller ON seller_documents(seller_user_id);

CREATE TABLE seller_locations (
                                  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                  seller_user_id UUID NOT NULL REFERENCES seller_profiles(user_id) ON DELETE RESTRICT,
                                  branch_name    VARCHAR(200) NOT NULL,
                                  address        TEXT NOT NULL,
                                  city           VARCHAR(100) NOT NULL,
                                  phone          VARCHAR(30),
                                  opening_hours  JSONB,
                                  latitude       NUMERIC(9,6),
                                  longitude      NUMERIC(9,6),
                                  is_active      BOOLEAN NOT NULL DEFAULT TRUE,
                                  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                  CONSTRAINT seller_location_coordinates_pair
                                      CHECK ((latitude IS NULL AND longitude IS NULL) OR (latitude IS NOT NULL AND longitude IS NOT NULL)),
                                  CONSTRAINT seller_location_latitude_range
                                      CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
                                  CONSTRAINT seller_location_longitude_range
                                      CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);
CREATE INDEX idx_seller_locations_seller ON seller_locations(seller_user_id);
CREATE INDEX idx_seller_locations_city   ON seller_locations(city);

CREATE TABLE categories (
                            id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                            parent_category_id UUID REFERENCES categories(id) ON DELETE RESTRICT,
                            name               VARCHAR(150) NOT NULL,
                            CONSTRAINT category_not_own_parent CHECK (parent_category_id IS NULL OR parent_category_id <> id)
);
CREATE INDEX idx_categories_parent ON categories(parent_category_id);

CREATE TABLE products (
                          id                    UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                          category_id           UUID NOT NULL REFERENCES categories(id) ON DELETE RESTRICT,
                          name                  VARCHAR(250) NOT NULL,
                          brand                 VARCHAR(150),
                          manufacturer          VARCHAR(200),
                          strength              VARCHAR(100),
                          dosage_form           VARCHAR(100),
                          barcode               VARCHAR(100) UNIQUE,
                          image_url             TEXT,
                          requires_prescription BOOLEAN NOT NULL DEFAULT FALSE,
                          created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_products_category ON products(category_id);

CREATE TABLE listings (
                          id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                          seller_location_id  UUID NOT NULL REFERENCES seller_locations(id) ON DELETE RESTRICT,
                          product_id          UUID NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
                          price               NUMERIC(12,2) NOT NULL CHECK (price >= 0),
                          currency            CHAR(3) NOT NULL DEFAULT 'EGP',
                          quantity_available  INTEGER NOT NULL DEFAULT 0 CHECK (quantity_available >= 0),
                          availability_status VARCHAR(30) NOT NULL DEFAULT 'unknown'
                              CHECK (availability_status IN ('in_stock', 'low_stock', 'out_of_stock', 'unknown')),
                          status              VARCHAR(30) NOT NULL DEFAULT 'draft'
                              CHECK (status IN ('draft', 'active', 'inactive', 'removed')),
                          created_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          updated_at          TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          CONSTRAINT listing_currency_uppercase CHECK (currency = UPPER(currency)),
                          CONSTRAINT one_product_listing_per_location UNIQUE (seller_location_id, product_id)
);
CREATE INDEX idx_listings_product_status  ON listings(product_id, status);
CREATE INDEX idx_listings_location_status ON listings(seller_location_id, status);
CREATE INDEX idx_listings_availability    ON listings(availability_status);

CREATE TABLE availability_alerts (
                                     id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                     buyer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                                     product_id    UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
                                     radius_km     NUMERIC(8,2) NOT NULL DEFAULT 5 CHECK (radius_km > 0),
                                     latitude      NUMERIC(9,6),
                                     longitude     NUMERIC(9,6),
                                     is_active     BOOLEAN NOT NULL DEFAULT TRUE,
                                     created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                                     CONSTRAINT alert_coordinates_pair
                                         CHECK ((latitude IS NULL AND longitude IS NULL) OR (latitude IS NOT NULL AND longitude IS NOT NULL)),
                                     CONSTRAINT alert_latitude_range
                                         CHECK (latitude IS NULL OR latitude BETWEEN -90 AND 90),
                                     CONSTRAINT alert_longitude_range
                                         CHECK (longitude IS NULL OR longitude BETWEEN -180 AND 180)
);
CREATE INDEX idx_alerts_buyer_active   ON availability_alerts(buyer_user_id, is_active);
CREATE INDEX idx_alerts_product_active ON availability_alerts(product_id, is_active);

CREATE TABLE notifications (
                               id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                               recipient_user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                               alert_id          UUID REFERENCES availability_alerts(id) ON DELETE SET NULL,
                               notification_type VARCHAR(50) NOT NULL,
                               delivery_status   VARCHAR(30) NOT NULL DEFAULT 'queued'
                                   CHECK (delivery_status IN ('queued', 'sent', 'delivered', 'failed')),
                               sent_at           TIMESTAMPTZ,
                               read_at           TIMESTAMPTZ,
                               created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_notifications_recipient_created ON notifications(recipient_user_id, created_at);

CREATE TABLE conversations (
                               id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                               buyer_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
                               seller_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
                               listing_id     UUID REFERENCES listings(id) ON DELETE SET NULL,
                               status         VARCHAR(30) NOT NULL DEFAULT 'open'
                                   CHECK (status IN ('open', 'closed', 'blocked')),
                               created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                               CONSTRAINT conversation_participants_differ CHECK (buyer_user_id <> seller_user_id)
);
CREATE INDEX idx_conversations_buyer  ON conversations(buyer_user_id, created_at);
CREATE INDEX idx_conversations_seller ON conversations(seller_user_id, created_at);

CREATE TABLE messages (
                          id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                          conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
                          sender_user_id  UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
                          message_text    TEXT,
                          attachment_url  TEXT,
                          sent_at         TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                          read_at         TIMESTAMPTZ,
                          CONSTRAINT message_has_content
                              CHECK (NULLIF(BTRIM(message_text), '') IS NOT NULL OR attachment_url IS NOT NULL)
);
CREATE INDEX idx_messages_conversation_sent ON messages(conversation_id, sent_at);

CREATE TABLE reviews (
                         id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                         reviewer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
                         seller_user_id   UUID NOT NULL REFERENCES seller_profiles(user_id) ON DELETE RESTRICT,
                         listing_id       UUID REFERENCES listings(id) ON DELETE SET NULL,
                         rating           SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
                         comment          TEXT,
                         created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                         CONSTRAINT reviewer_is_not_reviewed_seller CHECK (reviewer_user_id <> seller_user_id)
);
CREATE INDEX idx_reviews_seller_created ON reviews(seller_user_id, created_at);

CREATE TABLE reports (
                         id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                         reporter_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
                         reported_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
                         listing_id       UUID REFERENCES listings(id) ON DELETE SET NULL,
                         product_id       UUID REFERENCES products(id) ON DELETE SET NULL,
                         reason           TEXT NOT NULL,
                         status           VARCHAR(30) NOT NULL DEFAULT 'open'
                             CHECK (status IN ('open', 'under_review', 'resolved', 'dismissed')),
                         created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                         CONSTRAINT report_has_target
                             CHECK (reported_user_id IS NOT NULL OR listing_id IS NOT NULL OR product_id IS NOT NULL)
);
CREATE INDEX idx_reports_status_created ON reports(status, created_at);

CREATE TABLE audit_logs (
                            id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                            actor_user_id UUID REFERENCES users(id) ON DELETE SET NULL,
                            entity_type   VARCHAR(100) NOT NULL,
                            entity_id     UUID,
                            action        VARCHAR(100) NOT NULL,
                            details       JSONB NOT NULL DEFAULT '{}'::JSONB,
                            created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_audit_logs_entity        ON audit_logs(entity_type, entity_id, created_at);
CREATE INDEX idx_audit_logs_actor_created ON audit_logs(actor_user_id, created_at);

CREATE TABLE ai_workflows (
                              id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                              user_id          UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                              workflow_type    VARCHAR(80) NOT NULL,
                              goal             TEXT NOT NULL,
                              status           VARCHAR(30) NOT NULL DEFAULT 'queued'
                                  CHECK (status IN ('queued', 'running', 'waiting_for_approval', 'completed', 'failed', 'cancelled')),
                              agent_trace      JSONB NOT NULL DEFAULT '[]'::JSONB,   -- replaces ai_tasks
                              approval_status  VARCHAR(30) NOT NULL DEFAULT 'not_required'
                                  CHECK (approval_status IN ('not_required', 'pending', 'approved', 'rejected', 'expired')),
                              approval_payload JSONB,
                              approved_by      UUID REFERENCES users(id) ON DELETE SET NULL,
                              approved_at      TIMESTAMPTZ,
                              started_at       TIMESTAMPTZ,
                              completed_at     TIMESTAMPTZ,
                              created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
                              CONSTRAINT workflow_completion_after_start
                                  CHECK (completed_at IS NULL OR started_at IS NULL OR completed_at >= started_at)
);
CREATE INDEX idx_ai_workflows_user_status ON ai_workflows(user_id, status);

CREATE TABLE ai_messages (
                             id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                             workflow_id UUID NOT NULL REFERENCES ai_workflows(id) ON DELETE CASCADE,
                             role        VARCHAR(30) NOT NULL CHECK (role IN ('user', 'assistant', 'system', 'tool', 'agent')),
                             content     TEXT NOT NULL,
                             created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_ai_messages_workflow_created ON ai_messages(workflow_id, created_at);

CREATE TABLE prescriptions (
                               id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                               buyer_user_id UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
                               workflow_id   UUID REFERENCES ai_workflows(id) ON DELETE SET NULL,
                               image_url     TEXT NOT NULL,
                               ocr_text      TEXT,
                               status        VARCHAR(30) NOT NULL DEFAULT 'uploaded'
                                   CHECK (status IN ('uploaded', 'processing', 'parsed', 'awaiting_review', 'approved', 'completed', 'failed')),
                               created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_prescriptions_buyer_created ON prescriptions(buyer_user_id, created_at);
CREATE INDEX idx_prescriptions_status        ON prescriptions(status);

CREATE TABLE prescription_items (
                                    id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                    prescription_id    UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
                                    matched_product_id UUID REFERENCES products(id) ON DELETE SET NULL,
                                    parsed_name        VARCHAR(250) NOT NULL,
                                    strength           VARCHAR(100),
                                    dosage_form        VARCHAR(100),
                                    requested_quantity INTEGER NOT NULL DEFAULT 1 CHECK (requested_quantity > 0),
                                    status             VARCHAR(30) NOT NULL DEFAULT 'parsed'
                                        CHECK (status IN ('parsed', 'matched', 'partially_matched', 'unavailable', 'needs_review', 'approved'))
);
CREATE INDEX idx_prescription_items_prescription ON prescription_items(prescription_id);

CREATE TABLE pickup_plans (
                              id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                              prescription_id UUID NOT NULL REFERENCES prescriptions(id) ON DELETE CASCADE,
                              status          VARCHAR(30) NOT NULL DEFAULT 'draft'
                                  CHECK (status IN ('draft', 'proposed', 'pending_approval', 'approved', 'rejected', 'completed', 'cancelled')),
                              summary         TEXT,
                              created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_pickup_plans_prescription ON pickup_plans(prescription_id);

CREATE TABLE pickup_plan_items (
                                   id                   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                   pickup_plan_id       UUID NOT NULL REFERENCES pickup_plans(id) ON DELETE CASCADE,
                                   prescription_item_id UUID NOT NULL REFERENCES prescription_items(id) ON DELETE RESTRICT,
                                   listing_id           UUID NOT NULL REFERENCES listings(id) ON DELETE RESTRICT,  -- stop location = listing.seller_location_id
                                   stop_order           INTEGER NOT NULL CHECK (stop_order > 0),
                                   allocated_quantity   INTEGER NOT NULL CHECK (allocated_quantity > 0),
                                   CONSTRAINT unique_item_allocation UNIQUE (pickup_plan_id, prescription_item_id, listing_id)
);
CREATE INDEX idx_pickup_plan_items_plan_stop         ON pickup_plan_items(pickup_plan_id, stop_order);
CREATE INDEX idx_pickup_plan_items_prescription_item ON pickup_plan_items(prescription_item_id);
CREATE INDEX idx_pickup_plan_items_listing           ON pickup_plan_items(listing_id);