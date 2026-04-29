// Cloud Function that returns the HTTP method and request body

export const helloWorld = (req, res) => {
  res.json({ method: req.method, message: req.body });
};
