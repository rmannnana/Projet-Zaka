/** Indicatifs téléphoniques des pays UEMOA. */
const DIAL_CODES: Record<string, string> = {
  "+226": "BF",
  "+229": "BJ",
  "+225": "CI",
  "+245": "GW",
  "+223": "ML",
  "+227": "NE",
  "+221": "SN",
  "+228": "TG",
};

/** Déduit le pays UEMOA d'un numéro au format E.164 (ex. "+22670123456"). */
export function countryFromPhone(phone: string | null | undefined): string | null {
  if (!phone) return null;
  const prefix = Object.keys(DIAL_CODES).find((code) => phone.startsWith(code));
  return prefix ? DIAL_CODES[prefix] : null;
}
