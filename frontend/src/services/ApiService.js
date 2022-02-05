import axios from "axios";

const apiClient = axios.create({
  baseURL: 'http://localhost:4001',
  withCredentials: false,
  headers: {
    Accept: 'application/json',
    'Content-Type': 'application/json'
  }
})

export default {
  userEnters(name, token) {
    return apiClient.post('/user_enters/' + name, {token: token})
  },
  gameInfo(uuid) {
    return apiClient.get('/game_info/' + uuid)
  }
}
