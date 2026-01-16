// Hello controller
const getHello = (req, res) => {
  res.json({
    success: true,
    message: 'Hello from backend 👋',
  });
};

module.exports = {
  getHello,
};

