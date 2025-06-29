import * as React from "react";
import { cast } from "ts-safe-cast";

import { SettingPage } from "$app/parsers/settings";
import { asyncVoid } from "$app/utils/promise";
import { request, assertResponseError } from "$app/utils/request";

import { showAlert } from "$app/components/server-components/Alert";
import { Layout } from "$app/components/Settings/Layout";

type Props = {
  settings_pages: SettingPage[];
  is_form_disabled: boolean;
  billing_detail: {
    full_name: string | null;
    business_name: string | null;
    business_id: string | null;
    street_address: string | null;
    city: string | null;
    state: string | null;
    zip_code: string | null;
    country_code: string | null;
    additional_notes: string | null;
  };
  countries: Record<string, string>;
  states: { code: string; name: string }[];
};

function BillingSettingsPage(props: Props) {
  const uid = React.useId();
  const [isSaving, setIsSaving] = React.useState(false);
  const [billingDetails, setBillingDetails] = React.useState({
    full_name: props.billing_detail.full_name || "",
    business_name: props.billing_detail.business_name || "",
    business_id: props.billing_detail.business_id || "",
    street_address: props.billing_detail.street_address || "",
    city: props.billing_detail.city || "",
    state: props.billing_detail.state || "",
    zip_code: props.billing_detail.zip_code || "",
    country_code: props.billing_detail.country_code || "",
    additional_notes: props.billing_detail.additional_notes || "",
  });

  const updateBillingDetails = (details: Partial<typeof billingDetails>) =>
    setBillingDetails((prev) => ({ ...prev, ...details }));

  const onSave = asyncVoid(async () => {
    if (props.is_form_disabled) return;

    setIsSaving(true);

    try {
      const response = await request({
        url: "/settings/billing",
        method: "PUT",
        accept: "json",
        data: { billing_detail: billingDetails },
      });
      const responseData = cast<{ success: true } | { success: false; error_message: string }>(await response.json());
      if (responseData.success) {
        showAlert("Your billing details have been updated!", "success");
      } else {
        showAlert(responseData.error_message, "error");
      }
    } catch (e) {
      assertResponseError(e);
      showAlert("Sorry, something went wrong. Please try again.", "error");
    }

    setIsSaving(false);
  });

  return (
    <Layout
      pages={props.settings_pages}
      currentPage="billing"
      onSave={onSave}
      canUpdate={!props.is_form_disabled && !isSaving}
    >
      <section style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "var(--spacer-4)" }}>
        <div>
          <h2>Personal information</h2>
          <div>Enter your full legal name as it appears on official documents.</div>
        </div>
        <div>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-full-name`}>Full name</label>
            </legend>
            <input
              type="text"
              id={`${uid}-full-name`}
              value={billingDetails.full_name}
              onChange={(e) => updateBillingDetails({ full_name: e.target.value })}
              disabled={props.is_form_disabled}
              required
            />
          </fieldset>
        </div>
      </section>
      <section style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "var(--spacer-4)" }}>
        <div>
          <h2>Business information</h2>
          <div>If you're running a business, provide your business details and tax registration information.</div>
        </div>
        <div>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-business-name`}>Business name</label>
            </legend>
            <input
              type="text"
              id={`${uid}-business-name`}
              value={billingDetails.business_name}
              onChange={(e) => updateBillingDetails({ business_name: e.target.value })}
              disabled={props.is_form_disabled}
              placeholder="Optional"
            />
          </fieldset>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-business-id`}>Business ID</label>
            </legend>
            <input
              type="text"
              id={`${uid}-business-id`}
              value={billingDetails.business_id}
              onChange={(e) => updateBillingDetails({ business_id: e.target.value })}
              disabled={props.is_form_disabled}
              placeholder="VAT ID, GST number, etc."
            />
          </fieldset>
        </div>
      </section>
      <section style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "var(--spacer-4)" }}>
        <div>
          <h2>Address</h2>
          <div>Enter your complete billing address. This information will be used for tax and billing purposes.</div>
        </div>
        <div>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-street-address`}>Street address</label>
            </legend>
            <input
              type="text"
              id={`${uid}-street-address`}
              value={billingDetails.street_address}
              onChange={(e) => updateBillingDetails({ street_address: e.target.value })}
              disabled={props.is_form_disabled}
              required
            />
          </fieldset>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-city`}>City</label>
            </legend>
            <input
              type="text"
              id={`${uid}-city`}
              value={billingDetails.city}
              onChange={(e) => updateBillingDetails({ city: e.target.value })}
              disabled={props.is_form_disabled}
              required
            />
          </fieldset>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-country`}>Country</label>
            </legend>
            <select
              id={`${uid}-country`}
              value={billingDetails.country_code}
              onChange={(e) => updateBillingDetails({ country_code: e.target.value })}
              disabled={props.is_form_disabled}
              required
            >
              <option value="">Select a country</option>
              {Object.entries(props.countries).map(([code, name]) => (
                <option key={code} value={code}>
                  {name}
                </option>
              ))}
            </select>
          </fieldset>
          {billingDetails.country_code === "US" && (
            <fieldset>
              <legend>
                <label htmlFor={`${uid}-state`}>State</label>
              </legend>
              <select
                id={`${uid}-state`}
                value={billingDetails.state}
                onChange={(e) => updateBillingDetails({ state: e.target.value })}
                disabled={props.is_form_disabled}
                required
              >
                <option value="">Select a state</option>
                {props.states.map((state) => (
                  <option key={state.code} value={state.code}>
                    {state.name}
                  </option>
                ))}
              </select>
            </fieldset>
          )}
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-zip-code`}>ZIP code</label>
            </legend>
            <input
              type="text"
              id={`${uid}-zip-code`}
              value={billingDetails.zip_code}
              onChange={(e) => updateBillingDetails({ zip_code: e.target.value })}
              disabled={props.is_form_disabled}
              required
            />
          </fieldset>
        </div>
      </section>
      <section style={{ display: "grid", gridTemplateColumns: "1fr 2fr", gap: "var(--spacer-4)" }}>
        <div>
          <h2>Additional information</h2>
          <div>Include any additional notes or special instructions for your billing details.</div>
        </div>
        <div>
          <fieldset>
            <legend>
              <label htmlFor={`${uid}-additional-notes`}>Additional notes</label>
            </legend>
            <textarea
              id={`${uid}-additional-notes`}
              value={billingDetails.additional_notes}
              onChange={(e) => updateBillingDetails({ additional_notes: e.target.value })}
              disabled={props.is_form_disabled}
              rows={3}
              placeholder="Optional additional information"
            />
            <small>Any additional information for your billing details</small>
          </fieldset>
        </div>
      </section>
    </Layout>
  );
}

export default BillingSettingsPage;
