import axios from 'axios'

// users
export function currentUser () {
	return axios.get('/users/index/me');
}

export function getUsers () {
	return axios.get('/users/index');
}

export function getUser (id) {
	return axios.get('/users/index/' + id);
}

export function postUser (params) {
	return axios.post('/users/index', params);
}

export function patchUser (user) {
	return axios.patch('/users/index/' + user.id, user);
}

export function deleteUser (id) {
	return axios.delete('/users/index/' + id);
}

// books
export function getBooks (params) {
	return axios.get('/books', { params: params });
}

export function getBook (id) {
	return axios.get('/books/' + id);
}

export function postBook (params) {
	return axios.post('/books', params);
}

export function patchBook (book) {
	return axios.patch('/books/' + book.id, book);
}

export function deleteBook (id) {
	return axios.delete('/books/' + id);
}

// categories
export function getCategories () {
	return axios.get('/categories');
}

export function getCategory (id) {
	return axios.get('/categories/' + id);
}

export function postCategory (params) {
	return axios.post('/categories', params);
}

export function patchCategory (category) {
	return axios.patch('/categories/' + category.id, category);
}

export function deleteCategory (id) {
	return axios.delete('/categories/' + id);
}

// posts
export function indexPosts () {
	return axios.get('/posts');
}
export function createPost (params) {
	return axios.post('/posts', params);
}

export function deletePost (id) {
	return axios.delete('/posts/' + id);
}

export function closePost (id) {
	return axios.patch('/posts/' + id + '/close');
}

// comments
export function createComment (params) {
	return axios.post('/comments', params);
}

export function deleteComment (id) {
	return axios.delete('/comments/' + id);
}

// ratings
export function createRating (params) {
	return axios.post('/ratings', params);
}
